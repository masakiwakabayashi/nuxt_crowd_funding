export interface RewardTier {
  id: string;
  project_id: string;
  code: string | null;
  title: string;
  description: string | null;
  price: number;
  type: string;
  requires_shipping: boolean;
  estimated_delivery_date: string | null;
  max_backers: number | null;
  created_at: string;
  updated_at: string;
}

export type RewardTierInsert = {
  id?: string;
  project_id: string;
  title: string;
  price: number;
  code?: string | null;
  description?: string | null;
  type?: string;
  requires_shipping?: boolean;
  estimated_delivery_date?: string | null;
  max_backers?: number | null;
};

export type RewardTierUpdate = {
  id: string;
} & Partial<Omit<RewardTier, 'created_at' | 'updated_at'>>;
