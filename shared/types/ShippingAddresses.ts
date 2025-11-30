export interface ShippingAddress {
  id: string;
  backer_id: string;
  project_id: string;
  name: string;
  postal_code: string | null;
  prefecture: string | null;
  address_line1: string | null;
  address_line2: string | null;
  address_line3: string | null;
  country: string | null;
  phone: string | null;
  is_default: boolean;
  created_at: string;
  updated_at: string;
}

export type ShippingAddressInsert = {
  id?: string;
  backer_id: string;
  project_id: string;
  name: string;
  postal_code?: string | null;
  prefecture?: string | null;
  address_line1?: string | null;
  address_line2?: string | null;
  address_line3?: string | null;
  country?: string | null;
  phone?: string | null;
  is_default?: boolean;
};

export type ShippingAddressUpdate = {
  id: string;
} & Partial<Omit<ShippingAddress, 'created_at' | 'updated_at'>>;
