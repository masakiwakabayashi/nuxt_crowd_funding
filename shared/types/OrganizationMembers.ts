export type OrganizationMemberRole = 'admin' | 'staff' | 'viewer';

export interface OrganizationMember {
  id: string;
  organization_id: string;
  user_id: string;
  role: OrganizationMemberRole;
  created_at: string;
  updated_at: string;
}
