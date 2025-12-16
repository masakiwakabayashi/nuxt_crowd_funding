export interface Supporter {
  id: string;
  project_id: string;
  name: string;
  address: string | null;
  email: string | null;
  pledged_amount: number;
  created_at: string;
  updated_at: string;
}

export type SupporterInsert = {
  id?: string;
  project_id: string;
  name: string;
  address?: string | null;
  email?: string | null;
  pledged_amount?: number;
};

export type SupporterUpdate = {
  id: string;
} & Partial<Omit<Supporter, 'created_at' | 'updated_at'>>;
