export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      activity_logs: {
        Row: {
          id: string
          user_id: string | null
          action_type: string
          entity_id: string | null
          details: Json | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id?: string | null
          action_type: string
          entity_id?: string | null
          details?: Json | null
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string | null
          action_type?: string
          entity_id?: string | null
          details?: Json | null
          created_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "activity_logs_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          }
        ]
      }
      gallery_items: {
        Row: {
          caption: string | null
          created_at: string
          id: string
          image_url: string
          instagram_url: string | null
          sort_order: number
          status: Database["public"]["Enums"]["content_status"]
          title: string | null
          updated_at: string
        }
        Insert: {
          caption?: string | null
          created_at?: string
          id?: string
          image_url: string
          instagram_url?: string | null
          sort_order?: number
          status?: Database["public"]["Enums"]["content_status"]
          title?: string | null
          updated_at?: string
        }
        Update: {
          caption?: string | null
          created_at?: string
          id?: string
          image_url?: string
          instagram_url?: string | null
          sort_order?: number
          status?: Database["public"]["Enums"]["content_status"]
          title?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      maintenance_items: {
        Row: {
          created_at: string
          id: string
          interval_km: number | null
          interval_months: number | null
          last_change_date: string | null
          last_change_km: number | null
          motorcycle_id: string
          name: string
          notes: string | null
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          interval_km?: number | null
          interval_months?: number | null
          last_change_date?: string | null
          last_change_km?: number | null
          motorcycle_id: string
          name: string
          notes?: string | null
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          interval_km?: number | null
          interval_months?: number | null
          last_change_date?: string | null
          last_change_km?: number | null
          motorcycle_id?: string
          name?: string
          notes?: string | null
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "maintenance_items_motorcycle_id_fkey"
            columns: ["motorcycle_id"]
            isOneToOne: false
            referencedRelation: "motorcycles"
            referencedColumns: ["id"]
          },
        ]
      }
      maintenance_records: {
        Row: {
          cost: number | null
          created_at: string
          id: string
          item_name: string
          km_at_service: number | null
          maintenance_item_id: string | null
          motorcycle_id: string
          notes: string | null
          service_date: string
          user_id: string
          workshop: string | null
        }
        Insert: {
          cost?: number | null
          created_at?: string
          id?: string
          item_name: string
          km_at_service?: number | null
          maintenance_item_id?: string | null
          motorcycle_id: string
          notes?: string | null
          service_date?: string
          user_id: string
          workshop?: string | null
        }
        Update: {
          cost?: number | null
          created_at?: string
          id?: string
          item_name?: string
          km_at_service?: number | null
          maintenance_item_id?: string | null
          motorcycle_id?: string
          notes?: string | null
          service_date?: string
          user_id?: string
          workshop?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "maintenance_records_maintenance_item_id_fkey"
            columns: ["maintenance_item_id"]
            isOneToOne: false
            referencedRelation: "maintenance_items"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "maintenance_records_motorcycle_id_fkey"
            columns: ["motorcycle_id"]
            isOneToOne: false
            referencedRelation: "motorcycles"
            referencedColumns: ["id"]
          },
        ]
      }
      motorcycles: {
        Row: {
          brand: string
          color: string | null
          created_at: string
          current_km: number
          id: string
          model: string
          nickname: string | null
          photo_url: string | null
          plate: string | null
          updated_at: string
          user_id: string
          year: number | null
        }
        Insert: {
          brand: string
          color?: string | null
          created_at?: string
          current_km?: number
          id?: string
          model: string
          nickname?: string | null
          photo_url?: string | null
          plate?: string | null
          updated_at?: string
          user_id: string
          year?: number | null
        }
        Update: {
          brand?: string
          color?: string | null
          created_at?: string
          current_km?: number
          id?: string
          model?: string
          nickname?: string | null
          photo_url?: string | null
          plate?: string | null
          updated_at?: string
          user_id?: string
          year?: number | null
        }
        Relationships: []
      }
      news: {
        Row: {
          author_id: string | null
          content: string | null
          cover_url: string | null
          created_at: string
          excerpt: string | null
          id: string
          published_at: string | null
          slug: string
          status: Database["public"]["Enums"]["content_status"]
          tag: string | null
          title: string
          updated_at: string
        }
        Insert: {
          author_id?: string | null
          content?: string | null
          cover_url?: string | null
          created_at?: string
          excerpt?: string | null
          id?: string
          published_at?: string | null
          slug: string
          status?: Database["public"]["Enums"]["content_status"]
          tag?: string | null
          title: string
          updated_at?: string
        }
        Update: {
          author_id?: string | null
          content?: string | null
          cover_url?: string | null
          created_at?: string
          excerpt?: string | null
          id?: string
          published_at?: string | null
          slug?: string
          status?: Database["public"]["Enums"]["content_status"]
          tag?: string | null
          title?: string
          updated_at?: string
        }
        Relationships: []
      }
      profiles: {
        Row: {
          avatar_url: string | null
          birthdate: string | null
          city: string | null
          created_at: string
          full_name: string | null
          id: string
          instagram: string | null
          member_type: string | null
          nickname: string | null
          partner_id: string | null
          phone: string | null
          updated_at: string
        }
        Insert: {
          avatar_url?: string | null
          birthdate?: string | null
          city?: string | null
          created_at?: string
          full_name?: string | null
          id: string
          instagram?: string | null
          member_type?: string | null
          nickname?: string | null
          partner_id?: string | null
          phone?: string | null
          updated_at?: string
        }
        Update: {
          avatar_url?: string | null
          birthdate?: string | null
          city?: string | null
          created_at?: string
          full_name?: string | null
          id?: string
          instagram?: string | null
          member_type?: string | null
          nickname?: string | null
          partner_id?: string | null
          phone?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "profiles_partner_id_fkey"
            columns: ["partner_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          }
        ]
      }
      routes: {
        Row: {
          created_at: string | null
          created_by: string | null
          description: string | null
          destination: string
          estimated_distance_km: number | null
          estimated_duration_mins: number | null
          id: string
          media_url: string | null
          meeting_point: string
          meeting_time: string
          route_type: string
          start_date: string
          status: string
          title: string
          visited_places: string | null
          waze_url: string | null
          has_financial_plan: boolean | null
          cover_url: string | null
        }
        Insert: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          destination: string
          estimated_distance_km?: number | null
          estimated_duration_mins?: number | null
          id?: string
          media_url?: string | null
          meeting_point: string
          meeting_time: string
          route_type?: string
          start_date: string
          status?: string
          title: string
          visited_places?: string | null
          waze_url?: string | null
          has_financial_plan?: boolean | null
          cover_url?: string | null
        }
        Update: {
          created_at?: string | null
          created_by?: string | null
          description?: string | null
          destination?: string
          estimated_distance_km?: number | null
          estimated_duration_mins?: number | null
          id?: string
          media_url?: string | null
          meeting_point?: string
          meeting_time?: string
          route_type?: string
          start_date?: string
          status?: string
          title?: string
          visited_places?: string | null
          waze_url?: string | null
          has_financial_plan?: boolean | null
          cover_url?: string | null
        }
        Relationships: []
      }
      site_content: {
        Row: {
          key: string
          status: Database["public"]["Enums"]["content_status"]
          updated_at: string
          value: Json
        }
        Insert: {
          key: string
          status?: Database["public"]["Enums"]["content_status"]
          updated_at?: string
          value?: Json
        }
        Update: {
          key?: string
          status?: Database["public"]["Enums"]["content_status"]
          updated_at?: string
          value?: Json
        }
        Relationships: []
      }
      trip_financial_plans: {
        Row: {
          costs: Json
          created_at: string
          fuel_calc: Json
          has_passenger: boolean
          id: string
          observations: Json
          profile_id: string
          route_id: string
          updated_at: string
        }
        Insert: {
          costs?: Json
          created_at?: string
          fuel_calc?: Json
          has_passenger?: boolean
          id?: string
          observations?: Json
          profile_id: string
          route_id: string
          updated_at?: string
        }
        Update: {
          costs?: Json
          created_at?: string
          fuel_calc?: Json
          has_passenger?: boolean
          id?: string
          observations?: Json
          profile_id?: string
          route_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "trip_financial_plans_profile_id_fkey"
            columns: ["profile_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "trip_financial_plans_route_id_fkey"
            columns: ["route_id"]
            isOneToOne: false
            referencedRelation: "routes"
            referencedColumns: ["id"]
          }
        ]
      }
      user_roles: {
        Row: {
          created_at: string
          id: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          role: Database["public"]["Enums"]["app_role"]
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          role?: Database["public"]["Enums"]["app_role"]
          user_id?: string
        }
        Relationships: []
      }
      trip_expense_installments: {
        Row: {
          amount: number
          created_at: string
          due_date: string
          expense_id: string
          id: string
          installment_number: number
        }
        Insert: {
          amount: number
          created_at?: string
          due_date: string
          expense_id: string
          id?: string
          installment_number: number
        }
        Update: {
          amount?: number
          created_at?: string
          due_date?: string
          expense_id?: string
          id?: string
          installment_number?: number
        }
        Relationships: [
          {
            foreignKeyName: "trip_expense_installments_expense_id_fkey"
            columns: ["expense_id"]
            isOneToOne: false
            referencedRelation: "trip_shared_expenses"
            referencedColumns: ["id"]
          }
        ]
      }
      trip_installment_payments: {
        Row: {
          id: string
          installment_id: string
          is_paid: boolean | null
          paid_at: string | null
          plan_id: string
        }
        Insert: {
          id?: string
          installment_id: string
          is_paid?: boolean | null
          paid_at?: string | null
          plan_id: string
        }
        Update: {
          id?: string
          installment_id?: string
          is_paid?: boolean | null
          paid_at?: string | null
          plan_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "trip_installment_payments_installment_id_fkey"
            columns: ["installment_id"]
            isOneToOne: false
            referencedRelation: "trip_expense_installments"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "trip_installment_payments_plan_id_fkey"
            columns: ["plan_id"]
            isOneToOne: false
            referencedRelation: "trip_financial_plans"
            referencedColumns: ["id"]
          }
        ]
      }
      trip_shared_expenses: {
        Row: {
          created_at: string
          created_by: string | null
          description: string | null
          id: string
          participating_plans: string[]
          route_id: string
          title: string
          total_amount: number
        }
        Insert: {
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          participating_plans: string[]
          route_id: string
          title: string
          total_amount: number
        }
        Update: {
          created_at?: string
          created_by?: string | null
          description?: string | null
          id?: string
          participating_plans?: string[]
          route_id?: string
          title?: string
          total_amount?: number
        }
        Relationships: [
          {
            foreignKeyName: "trip_shared_expenses_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "trip_shared_expenses_route_id_fkey"
            columns: ["route_id"]
            isOneToOne: false
            referencedRelation: "routes"
            referencedColumns: ["id"]
          }
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      claim_admin_if_first: { Args: never; Returns: boolean }
      get_users_for_admin: {
        Args: never
        Returns: {
          banned_until: string
          created_at: string
          email: string
          full_name: string
          id: string
          role: Database["public"]["Enums"]["app_role"]
        }[]
      }
      has_role: {
        Args: {
          _role: Database["public"]["Enums"]["app_role"]
          _user_id: string
        }
        Returns: boolean
      }
      delete_user_completely: {
        Args: { target_user_id: string }
        Returns: undefined
      }
      get_todays_birthdays: {
        Args: Record<PropertyKey, never>
        Returns: {
          id: string
          full_name: string | null
          nickname: string | null
          avatar_url: string | null
          birthdate: string | null
        }[]
      }
      set_user_role: {
        Args: {
          new_role: Database["public"]["Enums"]["app_role"]
          target_user_id: string
        }
        Returns: undefined
      }
      toggle_user_ban: {
        Args: { ban: boolean; target_user_id: string }
        Returns: undefined
      }
    }
    Enums: {
      app_role: "admin" | "member" | "blog_admin"
      content_status: "draft" | "published"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {
      app_role: ["admin", "member", "blog_admin"],
      content_status: ["draft", "published"],
    },
  },
} as const

