defmodule ZeitWeb.Strings do
  @moduledoc false
  def title_text(:site, :show), do: "Show Site"
  def title_text(:site, :edit), do: "Edit Site"
  def title_text(:site, :diff), do: "Show Diff"
  def title_text(:site, :add_links), do: "Add Links"
  def title_text(:site, :import_sites), do: "Import sites"
  def title_text(:site, :report), do: "Monitoring Report"
  def note_text(:site, :edit), do: "NOTE: if site address changes then results will be lost"
  def note_text(:site, :new), do: "Sites are not enabled by default"
  def note_text(:site, :add_links), do: "Each link will be validated, invalid links are skipped"
  def note_text(:proxy, :edit), do: "NOTE: if address changes then old data will not be relevant"

  def note_text(:proxy, :new),
    do: "Proxies are available for all users and admins can manage them"

  def note_text(_, _), do: ""

  def submit_text(:site, :edit), do: "Save site"
  def submit_text(:site, :new), do: "Create site"
  def submit_text(:site, :add_links), do: "Add links"
  def submit_text(:site, :import_sites), do: "Import sites"
  def submit_text(:proxy, :edit), do: "Save proxy"
  def submit_text(:proxy, :new), do: "Create proxy"
  def submit_text(_, _), do: ""

  def get_error(nil), do: ""

  def get_error(error) do
    cond do
      String.contains?(error, "certificate_expired") ->
        "Certificate expired"

      String.contains?(error, "handshake_failure") ->
        "Handshake error"

      String.contains?(error, "bad_certificate") ->
        "Bad certificate"

      true ->
        [first, _] = String.split(error, ",")
        first
    end
  end

  def humanize_size(%Decimal{} = num_bytes) do
    num_bytes |> Decimal.to_integer() |> humanize_size()
  end

  def humanize_size(num_bytes) do
    Size.humanize!(
      num_bytes || 0,
      output: :string,
      round: 1,
      symbols: ~w(bytes Kb Mb Gb Tb Pb)
    )
  end
end
