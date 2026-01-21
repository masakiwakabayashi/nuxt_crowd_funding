import type { Project } from "./Project";

export interface Team {
  id: string;
  name: string;
  created_at: string;
  updated_at: string;
  projects?: Project[];
}
