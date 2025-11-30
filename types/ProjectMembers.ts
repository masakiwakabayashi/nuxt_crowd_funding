export interface ProjectMember {
  id: string;
  project_id: string;
  user_id: string;
  role: string;
  created_at: string;
  updated_at: string;
}

export type ProjectMemberInsert = {
  id?: string;
  project_id: string;
  user_id: string;
  role?: string;
};

export type ProjectMemberUpdate = {
  id: string;
} & Partial<Omit<ProjectMember, 'created_at' | 'updated_at'>>;
