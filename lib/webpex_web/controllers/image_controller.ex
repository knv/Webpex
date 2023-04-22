defmodule WebpexWeb.ImageController do
  use WebpexWeb, :controller

  def show(conn, %{"image_id" => image_id} = params) do
    case get_image_path(image_id) do
      :no_file ->
        conn
        |> send_resp(404, "")

      {image_path, image_suffix} ->
        case get_resize_params(params) do
          {width, quality} ->
            {:ok, img} = Vix.Vips.Operation.thumbnail(image_path, width)

            case is_webp(conn) do
              true ->
                {:ok, webp_image} = Vix.Vips.Image.write_to_buffer(img, ".webp[Q=#{quality}]")

                conn
                |> send_download({:binary, webp_image},
                  filename: "#{image_id}.webp",
                  disposition: :inline
                )

              false ->
                {:ok, image} =
                  Vix.Vips.Image.write_to_buffer(img, "#{image_suffix}[Q=#{quality}]")

                conn
                |> send_download({:binary, image},
                  filename: "#{image_id}#{image_suffix}",
                  disposition: :inline
                )
            end

          :invalid_params ->
            {:ok, img} = Vix.Vips.Image.new_from_file(image_path)

            case is_webp(conn) do
              true ->
                {:ok, webp_image} = Vix.Vips.Image.write_to_buffer(img, ".webp")

                conn
                |> send_download({:binary, webp_image},
                  filename: "#{image_id}.webp",
                  disposition: :inline
                )

              false ->
                {:ok, image} = Vix.Vips.Image.write_to_buffer(img, "#{image_suffix}")

                conn
                |> send_download({:binary, image},
                  filename: "#{image_id}#{image_suffix}",
                  disposition: :inline
                )
            end
        end
    end
  end

  def get_image_path(image_id) do
    data_directory = Application.get_env(:webpex, :runtime)[:data_directory]
    path = Path.join([data_directory, "#{image_id}"])

    case File.exists?("#{path}.jpg") do
      true ->
        {"#{path}.jpg", ".jpg"}

      false ->
        case File.exists?("#{path}.png") do
          true -> {"#{path}.png", ".png"}
          false -> :no_file
        end
    end
  end

  def get_image_cache_path(image_id) do
    data_directory = Application.get_env(:webpex, :runtime)[:data_directory]
    Path.join([data_directory, "cache", "#{image_id}.webp"])
  end

  def get_resize_params(%{"w" => w, "q" => q}) do
    valid_image_qualities = Application.get_env(:webpex, :runtime)[:valid_image_qualities]

    case do_get_resize_params(Integer.parse(w), Integer.parse(q), valid_image_qualities) do
      {width, quality} ->
        {width, quality}

      :invalid_params ->
        :invalid_params
    end
  end
  def get_resize_params(_) do
    :invalid_params
  end

  def do_get_resize_params({width, _}, {quality, _}, valid_image_qualities) do
    case quality in valid_image_qualities do
      true ->
        {width, quality}

      false ->
        {width, 100}
        # :invalid_params
    end
  end
  def do_get_resize_params({width, _}, :error, _) do
    {width, 100}
  end
  def do_get_resize_params(_, _, _) do
    :invalid_params
  end

  defp is_webp(conn) do
    conn
    |> get_req_header("accept")
    |> hd
    |> String.split(",")
    |> Enum.filter(fn x -> Enum.at(String.split(x, "/"), 1) == "webp" end)
    |> length
    |> Kernel.>(0)
  end
end
