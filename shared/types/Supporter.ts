export interface Supporter {
  id: string;
  project_id: string;
  name: string;
  address: string | null;
  email: string | null;
  pledged_amount: number;
  created_at: string;
  updated_at: string;
}
