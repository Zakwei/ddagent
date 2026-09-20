import type { CSSProperties, ReactNode, Ref } from 'react';

declare global {
  namespace JSX {
    interface IntrinsicElements {
      webview: {
        src?: string;
        partition?: string;
        allowpopups?: string;
        useragent?: string;
        className?: string;
        style?: CSSProperties;
        ref?: Ref<HTMLElement>;
        children?: ReactNode;
        [key: string]: unknown;
      };
    }
  }
}

export {};
