import type { Reward } from "./Rewards";
import type { Delivery } from "#imports";

export interface Project {
  id: string;
  team_id: string;
  title: string;
  description: string | null;
  start_at: string;
  end_at: string;
  goal: number;
  created_at: string;
  updated_at: string;
  rewards?: Reward[];
  deliveries?: Delivery[];
}
