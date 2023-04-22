defmodule WebpexWeb.ImageControllerTest do
  use WebpexWeb.ConnCase, async: true

  describe "Image resize" do
    setup do
      conn =
        build_conn()
        |> put_req_header("accept", "image/jpg, image/png")

      {:ok, %{conn: conn}}
    end

    test "GET raw jpg image from jpg", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/e4311721c44143099cbc48c3821ab26a"
        )

      res = response(conn, 200)
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadJpegBuffer"}
      assert res
    end

    test "GET raw png image from png", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/a1c6e03c7ace4dc0a2de167db918eaf7"
        )

      res = response(conn, 200)
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadPngBuffer"}
      assert res
    end

    test "GET non-existent image", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/nonexistentimage"
        )

      assert response(conn, 404)
    end

    test "GET resized jpg from jpg with 100% quality", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/e4311721c44143099cbc48c3821ab26a?w=200&q=100"
        )

      res = response(conn, 200)

      assert byte_size(res) == 31800
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadJpegBuffer"}

      {:ok, {img, _}} = Vix.Vips.Operation.jpegload_buffer(res)
      image_width = Vix.Vips.Image.width(img)

      assert image_width == 200
      assert res
    end

    test "GET resized jpg from jpg with 80% quality", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/e4311721c44143099cbc48c3821ab26a?w=200&q=80"
        )

      res = response(conn, 200)
      assert byte_size(res) == 5937
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadJpegBuffer"}

      {:ok, {img, _}} = Vix.Vips.Operation.jpegload_buffer(res)
      image_width = Vix.Vips.Image.width(img)

      assert image_width == 200
      assert res
    end
  end

  describe "Image resize and Convert to webp" do

    setup do
      conn =
        build_conn()
        |> put_req_header("accept", "image/webp")
        |> put_req_header("content-type", "image/webp")

      {:ok, %{conn: conn}}
    end

    test "GET raw webp image from jpg", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/e4311721c44143099cbc48c3821ab26a"
        )

      res = response(conn, 200)
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadWebpBuffer"}
      assert res
    end

    test "GET raw webp image from png", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/a1c6e03c7ace4dc0a2de167db918eaf7"
        )

      res = response(conn, 200)
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadWebpBuffer"}
      assert res
    end

    test "GET non-existent image", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/nonexistentimage"
        )

      assert response(conn, 404)
    end

    test "GET resized webp from jpg with 100% quality", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/e4311721c44143099cbc48c3821ab26a?w=200&q=100"
        )

      res = response(conn, 200)

      assert byte_size(res) == 13058
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadWebpBuffer"}

      {:ok, {img, _}} = Vix.Vips.Operation.webpload_buffer(res)
      image_width = Vix.Vips.Image.width(img)

      assert image_width == 200
      assert res
    end

    test "GET resized webp from jpg with 80% quality", %{conn: conn} do
      conn =
        get(
          conn,
          ~p"/image/e4311721c44143099cbc48c3821ab26a?w=200&q=80"
        )

      res = response(conn, 200)
      assert byte_size(res) == 4192
      assert Vix.Vips.Foreign.find_load_buffer(res) == {:ok, "VipsForeignLoadWebpBuffer"}

      {:ok, {img, _}} = Vix.Vips.Operation.webpload_buffer(res)
      image_width = Vix.Vips.Image.width(img)

      assert image_width == 200
      assert res
    end
  end
end
