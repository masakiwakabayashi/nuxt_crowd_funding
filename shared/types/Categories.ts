export interface Category {
  id: string;
  project_id: string;
  name: string;
  created_at: string;
  updated_at: string;
}

export type CategoryInsert = {
  id?: string;
  project_id: string;
  name: string;
};

export type CategoryUpdate = {
  id: string;
} & Partial<Omit<Category, 'created_at' | 'updated_at'>>;
