export interface Project {
  id: string;
  organization_id: string;
  name: string;
  platform: string | null;
  external_project_id: string | null;
  project_url: string | null;
  start_date: string | null;
  end_date: string | null;
  status: string;
  created_at: string;
  updated_at: string;
}

export type ProjectInsert = {
  id?: string;
  organization_id: string;
  name: string;
  platform?: string | null;
  external_project_id?: string | null;
  project_url?: string | null;
  start_date?: string | null;
  end_date?: string | null;
  status?: string;
};

export type ProjectUpdate = {
  id: string;
} & Partial<Omit<Project, 'created_at' | 'updated_at'>>;
