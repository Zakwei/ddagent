// Holds the in-process HTTP adapter (electron/transport/httpAdapter.js) once
// the backend bootstrap wires it up via createServices(). Until then the IPC
// channel stays registered and answers 503 instead of crashing.
let httpAdapter = null;

export function setHttpAdapter(adapter) {
  httpAdapter = adapter;
}

export function getHttpAdapter() {
  return httpAdapter;
}

export async function dispatchApiRequest(payload) {
  if (!httpAdapter) {
    return { status: 503, headers: {}, body: { error: 'local backend not started' } };
  }
  return httpAdapter.dispatch(payload);
}
