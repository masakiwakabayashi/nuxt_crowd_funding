export interface FulfillmentShipping {
  id: string;
  fulfillment_id: string;
  shipping_address_id: string;
  carrier: string | null;
  tracking_number: string | null;
  shipped_at: string | null;
  delivered_at: string | null;
  shipping_status: string | null;
  created_at: string;
  updated_at: string;
}

export type FulfillmentShippingInsert = {
  id?: string;
  fulfillment_id: string;
  shipping_address_id: string;
  carrier?: string | null;
  tracking_number?: string | null;
  shipped_at?: string | null;
  delivered_at?: string | null;
  shipping_status?: string | null;
};

export type FulfillmentShippingUpdate = {
  id: string;
} & Partial<Omit<FulfillmentShipping, 'created_at' | 'updated_at'>>;
