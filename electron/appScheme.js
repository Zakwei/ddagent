// Custom privileged scheme serving the built app bundle (see protocol.handle
// in main.js and electron/staticProtocol.js). `local` is a fixed placeholder
// host so the app gets a stable origin for localStorage/partitioning.
export const APP_SCHEME = 'ddagent-app';
export const LOCAL_APP_URL = `${APP_SCHEME}://local/index.html`;
