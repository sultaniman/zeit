defmodule Zeit.SitesTest do
  use Zeit.DataCase

  alias Zeit.Sites

  describe "sites" do
    alias Zeit.Sites.Site

    @valid_attrs %{address: "some address", is_archive: true}
    @update_attrs %{address: "some updated address", is_archive: false}
    @invalid_attrs %{address: nil, is_archive: nil}

    def site_fixture(attrs \\ %{}) do
      {:ok, site} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sites.create_site()

      site
    end

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Sites.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Sites.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      assert {:ok, %Site{} = site} = Sites.create_site(@valid_attrs)
      assert site.address == "some address"
      assert site.is_archive == true
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()
      assert {:ok, %Site{} = site} = Sites.update_site(site, @update_attrs)
      assert site.address == "some updated address"
      assert site.is_archive == false
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Sites.update_site(site, @invalid_attrs)
      assert site == Sites.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Sites.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Sites.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Sites.change_site(site)
    end
  end
end
