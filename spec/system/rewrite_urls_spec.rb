# frozen_string_literal: true

RSpec.describe "Rewrite URLs for group members" do
  let!(:theme) { upload_theme_or_component }
  fab!(:group) { Fabricate(:group, name: "beta-testers") }
  fab!(:member, :user)
  fab!(:outsider, :user)
  fab!(:topic)
  fab!(:post) do
    Fabricate(
      :post,
      topic: topic,
      raw: "[old](https://dronescene.co.uk/page) [new](https://beta.dronescene.co.uk/page)",
    )
  end

  before { group.add(member) }

  def enable_rewrite_all_urls
    theme.update_setting(:rewrite_all_urls, true)
    theme.save!
  end

  it "rewrites old_url links to new_url for group members" do
    sign_in(member)
    visit(topic.url)
    expect(page).to have_css("a[href='https://beta.dronescene.co.uk/page']", count: 2)
  end

  it "leaves links untouched for non-members by default" do
    sign_in(outsider)
    visit(topic.url)
    expect(page).to have_css("a[href='https://dronescene.co.uk/page']")
    expect(page).to have_css("a[href='https://beta.dronescene.co.uk/page']")
  end

  it "rewrites new_url links back to old_url for non-members when rewrite_all_urls is on" do
    enable_rewrite_all_urls
    sign_in(outsider)
    visit(topic.url)
    expect(page).to have_css("a[href='https://dronescene.co.uk/page']", count: 2)
  end

  it "rewrites new_url links back to old_url for anonymous users when rewrite_all_urls is on" do
    enable_rewrite_all_urls
    visit(topic.url)
    expect(page).to have_css("a[href='https://dronescene.co.uk/page']", count: 2)
  end
end
