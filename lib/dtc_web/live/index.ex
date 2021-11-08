defmodule DtcWeb.PageLive.Index do
  @moduledoc """
  module_doc
  """
  use DtcWeb, :live_view
  alias Phoenix.LiveView.JS
  @months [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
  ]

  @days ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

  @impl true
  def mount(_params, _session, socket) do
    date = DateTime.now!("Australia/Brisbane") |> DateTime.to_date()

    socket =
      socket
      |> assign(months: @months)
      |> assign(days: @days)
      |> assign(date: date)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("select-date", %{"date" => date}, socket) do
    {:ok, date} = Date.from_iso8601(date)
    {:noreply, assign(socket, date: date)}
  end

  def handle_event("next-month", _, socket) do
    date = socket.assigns.date
    days_in_month = Date.days_in_month(date)
    date = Date.add(date, days_in_month)
    {:noreply, assign(socket, date: date)}
  end

  def handle_event("prev-month", _, socket) do
    date = socket.assigns.date
    days_in_month = Date.days_in_month(date)
    date = Date.add(date, -days_in_month)
    {:noreply, assign(socket, date: date)}
  end

  defp week_rows(current_date) do
    first =
      current_date
      |> Date.beginning_of_month()
      |> Date.beginning_of_week(:sunday)

    last =
      current_date
      |> Date.end_of_month()
      |> Date.end_of_week(:sunday)

    Date.range(first, last) |> Enum.map(& &1) |> Enum.chunk_every(7)
  end

end
