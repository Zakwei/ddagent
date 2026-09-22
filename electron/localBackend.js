// Holds the in-process HTTP adapter (electron/transport/httpAdapter.js) once
// the backend bootstrap wires it up via createServices(). Until then both the
// IPC channel and the /api protocol route answer 503 instead of crashing.
let httpAdapter = null;
let apiDispatcher = null;

export function setHttpAdapter(adapter) {
  httpAdapter = adapter;
}

export function getHttpAdapter() {
  return httpAdapter;
}

// The ddagent-app:// protocol route speaks web Request/Response, so the
// dispatcher is a separate function from the IPC payload adapter. F1's
// bootstrap calls setApiDispatcher(adapter.dispatchRequest).
export function setApiDispatcher(dispatcher) {
  apiDispatcher = dispatcher;
}

export function getApiDispatcher() {
  return apiDispatcher;
}

// WebSocketServerDependencies + the Express app from createServices(), wired
// by the backend bootstrap for the WS-over-IPC router
// (electron/transport/wsRouter.js). Null until the backend is up — connects
// fail with close 1011 instead of importing server modules before env is set.
let wsDeps = null;
let backendApp = null;

export function setWsDeps(deps) {
  wsDeps = deps;
}

export function getWsDeps() {
  return wsDeps;
}

export function setBackendApp(app) {
  backendApp = app;
}

export function getBackendApp() {
  return backendApp;
}

// Legacy IPC payloads are { method, path, headers, body }; a web Request
// carries .url + .headers — duck-typed so cross-realm Requests still match.
function isWebRequest(value) {
  return (
    value != null &&
    typeof value === 'object' &&
    typeof value.method === 'string' &&
    typeof value.url === 'string'
  );
}

function apiNotStartedResponse() {
  return new Response(JSON.stringify({ error: 'local backend not started' }), {
    status: 503,
    headers: { 'content-type': 'application/json; charset=utf-8' },
  });
}

export async function dispatchApiRequest(input) {
  if (isWebRequest(input)) {
    if (!apiDispatcher) return apiNotStartedResponse();
    return apiDispatcher(input);
  }
  // Accepts both adapter shapes: the { dispatch } object from
  // createHttpAdapter and a bare dispatch function.
  const dispatch = typeof httpAdapter === 'function' ? httpAdapter : httpAdapter?.dispatch;
  if (typeof dispatch !== 'function') {
    return { status: 503, headers: {}, body: { error: 'local backend not started' } };
  }
  return dispatch(input);
}
