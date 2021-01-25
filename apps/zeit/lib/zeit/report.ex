defmodule Zeit.Report do
  @moduledoc false
  use TypedStruct

  alias Zeit.Sites.Site
  alias Zeit.Snapshots.Snapshot

  @typedoc "Report record"
  typedstruct do
    field :site, Site.t()
    field :snapshots, list(Snapshot.t())
  end
end
