export type TeamMemberRole = 'admin' | 'staff' | 'viewer';

export interface TeamMember {
  id: string;
  team_id: string;
  user_id: string;
  role: TeamMemberRole;
  created_at: string;
  updated_at: string;
}
