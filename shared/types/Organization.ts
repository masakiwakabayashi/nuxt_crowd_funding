import type { Project } from "./Project";

export interface Organization {
  id: string;
  name: string;
  created_at: string;
  updated_at: string;
  projects?: Project[];
}
