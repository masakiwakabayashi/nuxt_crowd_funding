export type DeliveryStatus = '未着手' | '作成中' | '完了';

export interface Delivery {
  id: string;
  return_id: string;
  supporter_id: string;
  status: DeliveryStatus;
  created_at: string;
  updated_at: string;
}

export type DeliveryInsert = {
  id?: string;
  return_id: string;
  supporter_id: string;
  status: DeliveryStatus;
};

export type DeliveryUpdate = {
  id: string;
} & Partial<Omit<Delivery, 'created_at' | 'updated_at'>>;
