import type { RGB } from '../lib/colors';

export type CategoryKey =
  | 'vibe' | 'whatIf' | 'story' | 'deep'
  | 'recentLife' | 'memories' | 'innerThoughts' | 'friendship'
  | 'excitement' | 'taste' | 'future'
  | 'firstImpression' | 'lifestyle' | 'values'
  | 'dailyLife' | 'honestly' | 'ahead'
  | 'parenting' | 'coupleLife' | 'hardships' | 'gratitude'
  | 'childhood' | 'familyStory' | 'generationGap'
  | 'workLife' | 'workStyle' | 'dreamsAndGoals' | 'afterWork'
  | 'coolDown' | 'myFeelings' | 'yourSide' | 'makingUp'
  | 'life'
  | 'travelStyle' | 'thisNow' | 'bucketList'
  | 'firstMeeting' | 'funQuestion' | 'unexpectedSide'
  | 'emotional' | 'philosophy' | 'confession' | 'dream'
  | 'lightChoice' | 'hardChoice' | 'wildChoice' | 'seriousChoice'
  | 'yearReview' | 'newYearResolution' | 'wish'
  | 'culture' | 'relationship'
  | 'adventure' | 'secret';

export interface Category {
  key: CategoryKey;
  /** i18n key: cat_<key>_name */
  nameKey: string;
  iconName: string;
  color: RGB;
  gameDrawCount: number;
}

// [iconName, color, gameDrawCount?] — gameDrawCount 기본 15.
const RAW: Record<CategoryKey, [string, RGB, number?]> = {
  vibe: ['sparkles', [0.2, 0.7, 0.5], 18],
  whatIf: ['cloud.fill', [0.9, 0.7, 0.2], 15],
  story: ['book.fill', [0.4, 0.5, 0.8], 15],
  deep: ['heart.circle.fill', [0.9, 0.35, 0.4], 12],
  recentLife: ['sun.max.fill', [0.95, 0.6, 0.2]],
  memories: ['photo.fill', [0.6, 0.4, 0.8]],
  innerThoughts: ['bubble.left.fill', [0.2, 0.7, 0.7]],
  friendship: ['person.2.fill', [0.3, 0.75, 0.4]],
  excitement: ['star.fill', [0.95, 0.4, 0.6]],
  taste: ['heart.fill', [0.9, 0.3, 0.5]],
  future: ['arrow.forward.circle.fill', [0.3, 0.5, 0.9]],
  firstImpression: ['eye.fill', [0.4, 0.4, 0.85]],
  lifestyle: ['figure.walk', [0.2, 0.65, 0.7]],
  values: ['checkmark.seal.fill', [0.35, 0.55, 0.8]],
  dailyLife: ['house.fill', [0.9, 0.55, 0.25]],
  honestly: ['mic.fill', [0.85, 0.25, 0.35]],
  ahead: ['map.fill', [0.25, 0.65, 0.45]],
  parenting: ['stroller.fill', [0.95, 0.5, 0.65]],
  coupleLife: ['person.2.circle.fill', [0.6, 0.35, 0.75]],
  hardships: ['cloud.rain.fill', [0.3, 0.5, 0.8]],
  gratitude: ['gift.fill', [0.9, 0.7, 0.15]],
  childhood: ['bicycle', [0.3, 0.7, 0.4]],
  familyStory: ['figure.2.and.child.holdinghands', [0.2, 0.55, 0.8]],
  generationGap: ['arrow.up.arrow.down.circle.fill', [0.85, 0.5, 0.2]],
  workLife: ['briefcase.fill', [0.3, 0.4, 0.75]],
  workStyle: ['laptopcomputer', [0.2, 0.6, 0.7]],
  dreamsAndGoals: ['flag.fill', [0.85, 0.25, 0.3]],
  afterWork: ['sunset.fill', [0.9, 0.55, 0.2]],
  coolDown: ['leaf.fill', [0.4, 0.7, 0.6]],
  myFeelings: ['heart.circle.fill', [0.85, 0.35, 0.5]],
  yourSide: ['person.fill.questionmark', [0.4, 0.5, 0.8]],
  makingUp: ['hands.clap.fill', [0.9, 0.65, 0.2]],
  life: ['book.closed.fill', [0.5, 0.35, 0.25]],
  travelStyle: ['airplane', [0.2, 0.6, 0.85]],
  thisNow: ['camera.fill', [0.2, 0.7, 0.65]],
  bucketList: ['list.star', [0.85, 0.65, 0.15]],
  firstMeeting: ['hand.wave.fill', [0.9, 0.55, 0.2]],
  funQuestion: ['questionmark.bubble.fill', [0.3, 0.75, 0.45]],
  unexpectedSide: ['theatermasks.fill', [0.65, 0.3, 0.75]],
  emotional: ['moon.stars.fill', [0.35, 0.35, 0.8]],
  philosophy: ['brain.head.profile', [0.55, 0.25, 0.75]],
  confession: ['envelope.fill', [0.9, 0.4, 0.6]],
  dream: ['cloud.moon.fill', [0.25, 0.4, 0.75]],
  lightChoice: ['tortoise.fill', [0.3, 0.7, 0.45]],
  hardChoice: ['bolt.fill', [0.85, 0.65, 0.15]],
  wildChoice: ['dice.fill', [0.9, 0.5, 0.2]],
  seriousChoice: ['exclamationmark.circle.fill', [0.35, 0.45, 0.8]],
  yearReview: ['calendar.circle.fill', [0.3, 0.5, 0.8]],
  newYearResolution: ['flag.checkered', [0.85, 0.25, 0.3]],
  wish: ['wand.and.stars', [0.85, 0.65, 0.15]],
  culture: ['building.columns.fill', [0.2, 0.6, 0.65]],
  relationship: ['person.2.wave.2.fill', [0.35, 0.5, 0.8]],
  adventure: ['mountain.2.fill', [0.3, 0.65, 0.35]],
  secret: ['lock.fill', [0.5, 0.3, 0.7]],
};

export const CATEGORIES = Object.fromEntries(
  Object.entries(RAW).map(([key, [iconName, color, draw]]) => [
    key,
    {
      key: key as CategoryKey,
      nameKey: `cat_${key}_name`,
      iconName,
      color,
      gameDrawCount: draw ?? 15,
    } satisfies Category,
  ])
) as Record<CategoryKey, Category>;

export function categoryOf(key: CategoryKey): Category {
  return CATEGORIES[key];
}
