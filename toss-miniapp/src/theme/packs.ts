import type { RGB } from '../lib/colors';
import type { CategoryKey } from './categories';

export type PackKey =
  | 'basic'
  | 'friends'
  | 'couple'
  | 'blindDate'
  | 'married'
  | 'babyParents'
  | 'family'
  | 'coworkers'
  | 'afterFight'
  | 'travel'
  | 'icebreaking'
  | 'lateNight'
  | 'wouldYouRather'
  | 'newYear'
  | 'hotTakes';

export interface Pack {
  key: PackKey;
  /** i18n keys: pack_<key>_name / pack_<key>_desc */
  nameKey: string;
  descKey: string;
  iconName: string;
  accentColor: RGB;
  categories: CategoryKey[];
}

export const PACKS: Record<PackKey, Pack> = {
  basic: {
    key: 'basic',
    nameKey: 'pack_basic_name',
    descKey: 'pack_basic_desc',
    iconName: 'rectangle.stack.fill',
    accentColor: [0.4, 0.5, 0.7],
    categories: ['vibe', 'whatIf', 'story', 'deep'],
  },
  friends: {
    key: 'friends',
    nameKey: 'pack_friends_name',
    descKey: 'pack_friends_desc',
    iconName: 'person.2.fill',
    accentColor: [0.3, 0.7, 0.4],
    categories: ['recentLife', 'memories', 'innerThoughts', 'friendship'],
  },
  couple: {
    key: 'couple',
    nameKey: 'pack_couple_name',
    descKey: 'pack_couple_desc',
    iconName: 'heart.fill',
    accentColor: [0.9, 0.3, 0.4],
    categories: ['excitement', 'taste', 'memories', 'future'],
  },
  blindDate: {
    key: 'blindDate',
    nameKey: 'pack_blindDate_name',
    descKey: 'pack_blindDate_desc',
    iconName: 'sparkles',
    accentColor: [0.9, 0.5, 0.7],
    categories: ['firstImpression', 'taste', 'lifestyle', 'values'],
  },
  married: {
    key: 'married',
    nameKey: 'pack_married_name',
    descKey: 'pack_married_desc',
    iconName: 'house.fill',
    accentColor: [0.6, 0.4, 0.8],
    categories: ['dailyLife', 'memories', 'honestly', 'ahead'],
  },
  babyParents: {
    key: 'babyParents',
    nameKey: 'pack_babyParents_name',
    descKey: 'pack_babyParents_desc',
    iconName: 'stroller.fill',
    accentColor: [0.95, 0.6, 0.3],
    categories: ['parenting', 'coupleLife', 'hardships', 'gratitude'],
  },
  family: {
    key: 'family',
    nameKey: 'pack_family_name',
    descKey: 'pack_family_desc',
    iconName: 'figure.2.and.child.holdinghands',
    accentColor: [0.2, 0.6, 0.8],
    categories: ['childhood', 'recentLife', 'familyStory', 'generationGap'],
  },
  coworkers: {
    key: 'coworkers',
    nameKey: 'pack_coworkers_name',
    descKey: 'pack_coworkers_desc',
    iconName: 'briefcase.fill',
    accentColor: [0.3, 0.3, 0.6],
    categories: ['workLife', 'workStyle', 'dreamsAndGoals', 'afterWork'],
  },
  afterFight: {
    key: 'afterFight',
    nameKey: 'pack_afterFight_name',
    descKey: 'pack_afterFight_desc',
    iconName: 'bolt.heart.fill',
    accentColor: [0.55, 0.4, 0.75],
    categories: ['coolDown', 'myFeelings', 'yourSide', 'makingUp'],
  },
  travel: {
    key: 'travel',
    nameKey: 'pack_travel_name',
    descKey: 'pack_travel_desc',
    iconName: 'airplane',
    accentColor: [0.2, 0.7, 0.7],
    categories: ['travelStyle', 'memories', 'thisNow', 'bucketList'],
  },
  icebreaking: {
    key: 'icebreaking',
    nameKey: 'pack_icebreaking_name',
    descKey: 'pack_icebreaking_desc',
    iconName: 'hand.wave.fill',
    accentColor: [0.9, 0.7, 0.2],
    categories: ['firstMeeting', 'taste', 'funQuestion', 'unexpectedSide'],
  },
  lateNight: {
    key: 'lateNight',
    nameKey: 'pack_lateNight_name',
    descKey: 'pack_lateNight_desc',
    iconName: 'moon.stars.fill',
    accentColor: [0.35, 0.35, 0.75],
    categories: ['emotional', 'philosophy', 'confession', 'dream'],
  },
  wouldYouRather: {
    key: 'wouldYouRather',
    nameKey: 'pack_wouldYouRather_name',
    descKey: 'pack_wouldYouRather_desc',
    iconName: 'arrow.left.arrow.right.circle.fill',
    accentColor: [0.9, 0.5, 0.2],
    categories: ['lightChoice', 'hardChoice', 'wildChoice', 'seriousChoice'],
  },
  newYear: {
    key: 'newYear',
    nameKey: 'pack_newYear_name',
    descKey: 'pack_newYear_desc',
    iconName: 'fireworks',
    accentColor: [0.85, 0.65, 0.15],
    categories: ['yearReview', 'gratitude', 'newYearResolution', 'wish'],
  },
  hotTakes: {
    key: 'hotTakes',
    nameKey: 'pack_hotTakes_name',
    descKey: 'pack_hotTakes_desc',
    iconName: 'flame.fill',
    accentColor: [0.9, 0.3, 0.2],
    categories: ['dailyLife', 'culture', 'relationship', 'life'],
  },
};

export const PACK_ORDER: PackKey[] = [
  'basic',
  'friends',
  'couple',
  'blindDate',
  'married',
  'babyParents',
  'family',
  'coworkers',
  'afterFight',
  'travel',
  'icebreaking',
  'lateNight',
  'wouldYouRather',
  'newYear',
  'hotTakes',
];

export const ALL_PACKS: Pack[] = PACK_ORDER.map((k) => PACKS[k]);
