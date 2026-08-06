import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  const user = api.getCurrentUser();
  api.decorateCookedElement((element) => {
    const inGroup = !!user?.groups?.some((g) => g.name === settings.group_name);
    // in group: old_url -> new_url; not in group: new_url -> old_url
    let from, to;
    if (inGroup) {
      from = settings.old_url;
      to = settings.new_url;
    } else if (settings.rewrite_all_urls) {
      from = settings.new_url;
      to = settings.old_url;
    } else {
      return;
    }
    element.querySelectorAll("a[href]").forEach((a) => {
      const href = a.getAttribute("href");
      if (href?.startsWith(from)) {
        a.setAttribute("href", href.replace(from, to));
      }
    });
  });
});
