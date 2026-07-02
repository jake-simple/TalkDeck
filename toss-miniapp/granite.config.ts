import { defineConfig } from '@apps-in-toss/web-framework/config';

// 앱인토스 미니앱 설정.
// displayName / icon / primaryColor 등은 토스 개발자센터 콘솔 등록 값과 맞춰야 합니다.
export default defineConfig({
  appName: 'icebreakingcard',
  web: {
    host: 'localhost',
    port: 3000,
    commands: {
      dev: 'rsbuild dev',
      build: 'rsbuild build',
    },
  },
  permissions: [],
  outdir: 'dist',
  brand: {
    displayName: '이야기 카드',
    // TODO: 토스 콘솔에 업로드한 실제 아이콘 URL로 교체
    icon: 'https://static.toss.im/appsintoss/placeholder/icebreakingcard-icon.png',
    primaryColor: '#5E63B6',
  },
  webViewProps: {
    type: 'partner',
  },
});
