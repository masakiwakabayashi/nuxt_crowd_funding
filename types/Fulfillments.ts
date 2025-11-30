export interface Fulfillment {
  id: string;
  pledge_item_id: string;
  project_id: string;
  backer_id: string;
  type: string;
  status: string;
  assigned_to: string | null;
  due_date: string | null;
  delivered_at: string | null;
  note: string | null;
  created_at: string;
  updated_at: string;
}

export type FulfillmentInsert = {
  id?: string;
  pledge_item_id: string;
  project_id: string;
  backer_id: string;
  type?: string;
  status?: string;
  assigned_to?: string | null;
  due_date?: string | null;
  delivered_at?: string | null;
  note?: string | null;
};

export type FulfillmentUpdate = {
  id: string;
} & Partial<Omit<Fulfillment, 'created_at' | 'updated_at'>>;
