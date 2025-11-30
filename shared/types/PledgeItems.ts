export interface PledgeItem {
  id: string;
  pledge_id: string;
  reward_tier_id: string;
  reward_variant_id: string | null;
  quantity: number;
  unit_price: number;
  note: string | null;
  created_at: string;
  updated_at: string;
}

export type PledgeItemInsert = {
  id?: string;
  pledge_id: string;
  reward_tier_id: string;
  unit_price: number;
  reward_variant_id?: string | null;
  quantity?: number;
  note?: string | null;
};

export type PledgeItemUpdate = {
  id: string;
} & Partial<Omit<PledgeItem, 'created_at' | 'updated_at'>>;
