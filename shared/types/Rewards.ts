export interface Reward {
  id: string;
  project_id: string;
  title: string;
  detail: string | null;
  max_quantity: number | null;
  category_id: string | null;
  price: number;
  estimated_delivery: string | null;
  created_at: string;
  updated_at: string;
}
