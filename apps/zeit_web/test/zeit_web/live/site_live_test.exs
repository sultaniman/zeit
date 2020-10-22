defmodule ZeitWeb.SiteLiveTest do
  use ZeitWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Zeit.Sites

  @create_attrs %{address: "some address", is_archive: true}
  @update_attrs %{address: "some updated address", is_archive: false}
  @invalid_attrs %{address: nil, is_archive: nil}

  defp fixture(:site) do
    {:ok, site} = Sites.create_site(@create_attrs)
    site
  end

  defp create_site(_) do
    site = fixture(:site)
    %{site: site}
  end

  describe "Index" do
    setup [:create_site]

    test "lists all sites", %{conn: conn, site: site} do
      {:ok, _index_live, html} = live(conn, Routes.site_index_path(conn, :index))

      assert html =~ "Listing Sites"
      assert html =~ site.address
    end

    test "saves new site", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.site_index_path(conn, :index))

      assert index_live |> element("a", "New Site") |> render_click() =~
               "New Site"

      assert_patch(index_live, Routes.site_index_path(conn, :new))

      assert index_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#site-form", site: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.site_index_path(conn, :index))

      assert html =~ "Site created successfully"
      assert html =~ "some address"
    end

    test "updates site in listing", %{conn: conn, site: site} do
      {:ok, index_live, _html} = live(conn, Routes.site_index_path(conn, :index))

      assert index_live |> element("#site-#{site.id} a", "Edit") |> render_click() =~
               "Edit Site"

      assert_patch(index_live, Routes.site_index_path(conn, :edit, site))

      assert index_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#site-form", site: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.site_index_path(conn, :index))

      assert html =~ "Site updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes site in listing", %{conn: conn, site: site} do
      {:ok, index_live, _html} = live(conn, Routes.site_index_path(conn, :index))

      assert index_live |> element("#site-#{site.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#site-#{site.id}")
    end
  end

  describe "Show" do
    setup [:create_site]

    test "displays site", %{conn: conn, site: site} do
      {:ok, _show_live, html} = live(conn, Routes.site_show_path(conn, :show, site))

      assert html =~ "Show Site"
      assert html =~ site.address
    end

    test "updates site within modal", %{conn: conn, site: site} do
      {:ok, show_live, _html} = live(conn, Routes.site_show_path(conn, :show, site))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Site"

      assert_patch(show_live, Routes.site_show_path(conn, :edit, site))

      assert show_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#site-form", site: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.site_show_path(conn, :show, site))

      assert html =~ "Site updated successfully"
      assert html =~ "some updated address"
    end
  end
end
