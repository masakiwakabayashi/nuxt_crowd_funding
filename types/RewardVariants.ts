export interface RewardVariant {
  id: string;
  reward_tier_id: string;
  name: string;
  code: string | null;
  extra_note: string | null;
  created_at: string;
  updated_at: string;
}

export type RewardVariantInsert = {
  id?: string;
  reward_tier_id: string;
  name: string;
  code?: string | null;
  extra_note?: string | null;
};

export type RewardVariantUpdate = {
  id: string;
} & Partial<Omit<RewardVariant, 'created_at' | 'updated_at'>>;
