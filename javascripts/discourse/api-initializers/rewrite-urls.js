import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  const user = api.getCurrentUser();
  api.decorateCookedElement((element) => {
    const inGroup = !!user?.groups?.some((g) => g.name === settings.group_name);
    // members see only new_url links; everyone else sees only old_url links
    const from = inGroup ? settings.old_url : settings.new_url;
    const to = inGroup ? settings.new_url : settings.old_url;
    element.querySelectorAll("a[href]").forEach((a) => {
      const href = a.getAttribute("href");
      if (href?.startsWith(from)) {
        a.setAttribute("href", href.replace(from, to));
        if (a.textContent.startsWith(from)) {
          a.textContent = a.textContent.replace(from, to);
        }
      }
    });
  });
});
