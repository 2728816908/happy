const { withAndroidManifest } = require('@expo/config-plugins');

/**
 * Allow cleartext (plain HTTP) traffic on Android when the configured server
 * URL uses http://.
 *
 * Why: Android targetSdk >= 28 blocks cleartext HTTP by default, so a *release*
 * APK cannot reach a self-hosted Happy server on a LAN address like
 * `http://192.168.x.x:3005` — `fetch()` throws and the server-config screen
 * reports "连接服务器失败". Debug builds work only because Expo injects
 * usesCleartextTraffic into the debug manifest (for Metro).
 *
 * This plugin sets android:usesCleartextTraffic="true" on the <application> tag
 * for self-hosted HTTP servers. HTTPS builds keep Android's default policy.
 */
module.exports = function withCleartextTraffic(config) {
    const serverUrl = process.env.EXPO_PUBLIC_HAPPY_SERVER_URL || '';
    if (!serverUrl.toLowerCase().startsWith('http://')) {
        return config;
    }

    return withAndroidManifest(config, (cfg) => {
        const application = cfg.modResults.manifest.application?.[0];
        if (application) {
            application.$['android:usesCleartextTraffic'] = 'true';
        }
        return cfg;
    });
};
