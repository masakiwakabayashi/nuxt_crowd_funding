export type OrganizationMemberRole = 'admin' | 'staff' | 'viewer';

export interface OrganizationMember {
  id: string;
  organization_id: string;
  user_id: string;
  role: OrganizationMemberRole;
  created_at: string;
  updated_at: string;
}

export type OrganizationMemberInsert = {
  id?: string;
  organization_id: string;
  user_id: string;
  role: OrganizationMemberRole;
};

export type OrganizationMemberUpdate = {
  id: string;
} & Partial<Omit<OrganizationMember, 'created_at' | 'updated_at'>>;
