import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  // Your code here (uncomment api above to use it)
  const user = api.getCurrentUser();
  api.decorateCookedElement((element) => {
    // see if user.group includes settings.group_name
    const groupName = settings.group_name;
    const group = user.groups.find((g) => g.name === groupName);
    if (!group) {
      return;
    }
    const urls = element.querySelectorAll("a[href]") || [];
    urls.forEach((url) => {
      const oldUrl = settings.old_url;
      const newUrl = settings.new_url;
      const href = url.getAttribute("href");
      if (href && href.startsWith(oldUrl)) {
        url.setAttribute("href", href.replace(oldUrl, newUrl));
      }
    });
  });
});
