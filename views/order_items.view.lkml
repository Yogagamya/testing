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

  parameter: date_granularity {
    type: unquoted
    allowed_value: {
      label: "Break down by Day"
      value: "day"
    }
    allowed_value: {
      label: "Break down by Month"
      value: "month"
    }
    allowed_value: {
      label: "Break down by year"
      value: "year"
      }
  }

  dimension: date {
    sql:
    {% if date_granularity._parameter_value == 'day' %}
      ${returned_date}
    {% elsif date_granularity._parameter_value == 'month' %}
      ${returned_month}
      % elsif date_granularity._parameter_value == 'year' %}
      ${returned_year}
    {% else %}
      ${returned_date}
    {% endif %};;
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
}
