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
      raw:
        "[old](https://dronescene.co.uk/page) [new](https://beta.dronescene.co.uk/page) and https://dronescene.co.uk/plain inline",
    )
  end

  before { group.add(member) }

  it "members see only new_url links, with link text rewritten too" do
    sign_in(member)
    visit(topic.url)
    expect(page).to have_css("a[href='https://beta.dronescene.co.uk/page']", count: 2)
    expect(page).to have_link(
      "https://beta.dronescene.co.uk/plain",
      href: "https://beta.dronescene.co.uk/plain",
    )
    expect(page).to have_no_css("a[href^='https://dronescene.co.uk']")
  end

  it "non-members see only old_url links" do
    sign_in(outsider)
    visit(topic.url)
    expect(page).to have_css("a[href='https://dronescene.co.uk/page']", count: 2)
    expect(page).to have_no_css("a[href^='https://beta.dronescene.co.uk']")
  end

  it "anonymous users see only old_url links" do
    visit(topic.url)
    expect(page).to have_css("a[href='https://dronescene.co.uk/page']", count: 2)
    expect(page).to have_no_css("a[href^='https://beta.dronescene.co.uk']")
  end
end
