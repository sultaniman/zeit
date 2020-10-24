defmodule ZeitWeb.Strings do
  @moduledoc false
  def title_text(:site, :show), do: "Show Site"
  def title_text(:site, :edit), do: "Edit Site"
  def title_text(:site, :diff), do: "Show Diff"
  def title_text(:site, :add_links), do: "Add Links"
  def note_text(:site, :edit), do: "NOTE: if site address changes then results will be lost"
  def note_text(:site, :new), do: "Sites are not enabled by default"
  def note_text(:site, :add_links), do: "Each link will be validated, invalid links are skipped"
  def note_text(:proxy, :edit), do: "NOTE: if address changes then old data will not be relevant"
  def note_text(:proxy, :new), do: "Proxies are available for all users and admins can manage them"
  def note_text(_, _), do: ""

  def submit_text(:site, :edit), do: "Save site"
  def submit_text(:site, :new), do: "Create site"
  def submit_text(:site, :add_links), do: "Add links"
  def submit_text(:proxy, :edit), do: "Save proxy"
  def submit_text(:proxy, :new), do: "Create proxy"
  def submit_text(_, _), do: ""
end
