# frozen_string_literal: true

# Methods to help across all application views.
module ApplicationHelper
  def simple_date(past_date)
    return '' if past_date.blank?
    if past_date == Time.zone.today
      'Today'
    elsif past_date == Time.zone.today - 1.day
      'Yesterday'
    elsif past_date == Time.zone.today + 1.day
      'Tomorrow'
    elsif past_date.year == Time.zone.today.year
      past_date.strftime('%b %d')
    else
      past_date.strftime('%b %d, %Y')
    end
  end

  def simple_time(past_time)
    return '' if past_time.blank?
    if past_time.to_date == Time.zone.today
      past_time.strftime('<b>Today</b> at %I:%M %p').html_safe
    elsif past_time.year == Time.zone.today.year
      past_time.strftime('on %b %d at %I:%M %p')
    else
      past_time.strftime('on %b %d, %Y at %I:%M %p')
    end
  end

  def simple_check(checked)
    checked ? icon("fas", "check-square") : icon("far", "square")
  end

  def th_sort_field(order, sort_field, display_name, extra_class: '')
    sort_params = params.permit(:search)
    sort_field_order = (order == sort_field) ? "#{sort_field} desc" : sort_field
    if order == sort_field
      selected_class = 'sort-selected'
    elsif order == "#{sort_field} desc nulls last" || order == "#{sort_field} desc"
      selected_class = 'sort-selected'
    end
    content_tag(:th, class: [selected_class, extra_class]) do
      link_to url_for(sort_params.merge(order: sort_field_order)), style: 'text-decoration:none' do
        display_name.to_s.html_safe
      end
    end.html_safe
  end
end
