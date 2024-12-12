view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }
  dimension: phones {
    type: string
    sql: ${TABLE}.phones ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }
measure:demo {
type: number
sql:${id};;
}
measure: demi{
sql:${id};;
}
  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }
  parameter: date_aggregation {
    type: unquoted
    allowed_value: {
      label: "Date"
      value: "date"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    default_value: "date"
    description: "Select the date aggregation level."
  }
  dimension: dynamic_order_creation_date {
    type: date
    sql: CASE
          WHEN {% parameter date_aggregation %} = 'week' THEN
            {% raw %} DATE_TRUNC('WEEK', ${TABLE}.order_creation_date) {% endraw %}
          WHEN {% parameter date_aggregation %} = 'month' THEN
            {% raw %} DATE_TRUNC('MONTH', ${TABLE}.order_creation_date) {% endraw %}
          ELSE
            ${TABLE}.order_creation_date
        END ;;
    label: "Order Creation Date"
    description: "Dynamic Order Creation Date based on selected aggregation."
  }
}
