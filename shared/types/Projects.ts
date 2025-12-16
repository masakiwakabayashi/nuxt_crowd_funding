export interface Project {
  id: string;
  organization_id: string;
  title: string;
  description: string | null;
  start_at: string;
  end_at: string;
  goal: number;
  created_at: string;
  updated_at: string;
}

export type ProjectInsert = {
  id?: string;
  organization_id: string;
  title: string;
  description?: string | null;
  start_at: string;
  end_at: string;
  goal: number;
};

export type ProjectUpdate = {
  id: string;
} & Partial<Omit<Project, 'created_at' | 'updated_at'>>;
