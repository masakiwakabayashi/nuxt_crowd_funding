export interface Backer {
  id: string;
  organization_id: string;
  name: string;
  email: string | null;
  phone: string | null;
  note: string | null;
  created_at: string;
  updated_at: string;
}

export type BackerInsert = {
  id?: string;
  organization_id: string;
  name: string;
  email?: string | null;
  phone?: string | null;
  note?: string | null;
};

export type BackerUpdate = {
  id: string;
} & Partial<Omit<Backer, 'created_at' | 'updated_at'>>;
