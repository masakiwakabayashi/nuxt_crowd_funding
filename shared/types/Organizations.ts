export interface Organization {
  id: string;
  name: string;
  plan: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export type OrganizationInsert = {
  id?: string;
  name: string;
  plan?: string;
  is_active?: boolean;
};

export type OrganizationUpdate = {
  id: string;
} & Partial<Omit<Organization, 'created_at' | 'updated_at'>>;
