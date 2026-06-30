// 앱인토스 콘솔에서 발급받은 광고 그룹 ID(adGroupId)로 교체하세요.
// (개발자센터 > 광고 > 광고 그룹 생성 후 ID 입력)
// 빌드 시 환경변수(AIT_AD_*)가 있으면 우선 사용합니다.
const env = (typeof process !== 'undefined' ? process.env : undefined) as
  | Record<string, string | undefined>
  | undefined;

export const AD_GROUP = {
  /** 하단 배너 광고 그룹 ID */
  banner: env?.AIT_AD_BANNER ?? 'REPLACE_WITH_BANNER_AD_GROUP_ID',
  /** 테마 변경 시 리워드(전면) 광고 그룹 ID */
  themeReward: env?.AIT_AD_THEME_REWARD ?? 'REPLACE_WITH_THEME_REWARD_AD_GROUP_ID',
  /** 카드팩 변경 시 리워드(전면) 광고 그룹 ID */
  packReward: env?.AIT_AD_PACK_REWARD ?? 'REPLACE_WITH_PACK_REWARD_AD_GROUP_ID',
};

/** 테마+카드팩 리워드를 모두 시청하면 부여되는 무제한 이용 시간 (1시간) */
export const UNLIMITED_DURATION_MS = 60 * 60 * 1000;
