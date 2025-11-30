export interface FulfillmentDigital {
  id: string;
  fulfillment_id: string;
  download_url: string | null;
  access_code: string | null;
  expires_at: string | null;
  download_count: number;
  last_accessed_at: string | null;
  created_at: string;
  updated_at: string;
}

export type FulfillmentDigitalInsert = {
  id?: string;
  fulfillment_id: string;
  download_url?: string | null;
  access_code?: string | null;
  expires_at?: string | null;
  download_count?: number;
  last_accessed_at?: string | null;
};

export type FulfillmentDigitalUpdate = {
  id: string;
} & Partial<Omit<FulfillmentDigital, 'created_at' | 'updated_at'>>;
