export interface Pledge {
  id: string;
  project_id: string;
  backer_id: string;
  external_pledge_id: string | null;
  pledged_amount: number;
  currency: string;
  pledged_at: string;
  status: string;
  created_at: string;
  updated_at: string;
}

export type PledgeInsert = {
  id?: string;
  project_id: string;
  backer_id: string;
  pledged_amount: number;
  external_pledge_id?: string | null;
  currency?: string;
  pledged_at?: string;
  status?: string;
};

export type PledgeUpdate = {
  id: string;
} & Partial<Omit<Pledge, 'created_at' | 'updated_at'>>;
