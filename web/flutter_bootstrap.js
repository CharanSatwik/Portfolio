/**
 * WARNING: DO NOT ADD SPACES TO THE TWO LINES BELOW.
 * IF THEY LOOK LIKE { { ... } }, THE APP WILL NOT LOAD.
 */
// prettier-ignore
{{flutter_js}}
// prettier-ignore
{{flutter_build_config}}

_flutter.loader.load({
  onProgress: function (value) {
    console.log("Flutter loading progress:", value);
  },
  onEntrypointLoaded: async function (engineInitializer) {
    console.log("Entrypoint loaded!");
    try {
      const appRunner = await engineInitializer.initializeEngine();
      console.log("Engine initialized!");

      await appRunner.runApp();
      console.log("App running!");

      // Smoothly fade out and remove the loading indicator
      const loadingIndicator = document.getElementById('loading-indicator');
      if (loadingIndicator) {
        loadingIndicator.style.opacity = '0';
        setTimeout(() => loadingIndicator.remove(), 500);
      }
    } catch (error) {
      console.error("Flutter initialization failed:", error);
    }
  }
});
