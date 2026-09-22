const { getDefaultConfig } = require('expo/metro-config');
const { withNativeWind } = require('nativewind/metro');
const path = require('path');

const projectRoot = __dirname;
const monorepoRoot = path.resolve(projectRoot, '..');

const config = getDefaultConfig(projectRoot);

// Watch the whole repo so ~shared/../src imports are picked up.
config.watchFolders = [monorepoRoot];

// Shared web files live in ../src and resolve imports relative to THEIR own
// directory — which would find root node_modules (react 18) and crash on a
// second React copy. Force react/react-native to always resolve from
// mobile/node_modules instead.
const mobileNodeModules = path.join(projectRoot, 'node_modules');
const FORCED_PACKAGES = /^(react|react-native|react-dom|scheduler|react-i18next|i18next|zustand)(\/|$)/;
const defaultResolveRequest = config.resolver.resolveRequest;
config.resolver.resolveRequest = (context, moduleName, platform) => {
  if (FORCED_PACKAGES.test(moduleName)) {
    return context.resolveRequest(
      { ...context, originModulePath: path.join(projectRoot, 'index.ts') },
      moduleName,
      platform,
    );
  }
  if (defaultResolveRequest) {
    return defaultResolveRequest(context, moduleName, platform);
  }
  return context.resolveRequest(context, moduleName, platform);
};
config.resolver.nodeModulesPaths = [
  mobileNodeModules,
  path.join(monorepoRoot, 'node_modules'),
];

module.exports = withNativeWind(config, { input: './global.css' });
