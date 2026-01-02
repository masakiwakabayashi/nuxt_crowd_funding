import type { Supporter } from "./Supporter";

export type DeliveryStatus = '未着手' | '作成中' | '完了';

export interface Delivery {
  id: string;
  project_id: string;
  reward_id: string;
  supporter_id: string;
  status: DeliveryStatus;
  created_at: string;
  updated_at: string;
  supporter?: Supporter;
  due_date: string;
}
