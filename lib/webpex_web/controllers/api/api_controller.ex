defmodule WebpexWeb.API.V1.APIController do
  use WebpexWeb, :controller

  def create(conn, %{
        "image_file" => %Plug.Upload{
          path: path,
          content_type: content_type
        },
        "image_id" => image_id
      }) do

    case String.trim(image_id) do
      "" ->
        create(conn, %{
          "image_file" => %Plug.Upload{
            path: path,
            content_type: content_type
          }})
      _ ->

        data_directory = Application.get_env(:imagex, :runtime)[:data_directory]
        filename = get_filename(content_type, image_id)
        case File.cp(
          path,
          Path.join([data_directory, filename])

        ) do
          :ok ->
            conn
            |> put_status(201)
            |> render(:create, filename: filename)
            # |> send_resp(201, %{data: %{filename: filename}})
          {:error, posix} ->
            conn
            |> send_resp(400, "#{posix}")

        end
    end


  end

  def create(conn, %{
    "image_file" => %Plug.Upload{
      path: path,
      content_type: content_type
    }
  }) do
    data_directory = Application.get_env(:imagex, :runtime)[:data_directory]
    image_id = UUID.uuid4(:hex)
    case File.cp(
      path,
      Path.join([data_directory, "#{image_id}.#{get_suffix(content_type)}"])
    ) do
      :ok ->
        conn
        |> send_resp(201, "")
      {:error, posix} ->
        conn
        |> send_resp(400, "#{posix}")

    end
  end

  def create(conn, _) do
    conn
      |> put_status(400)
      |> render(:error, error: "No file provided")
  end

  def delete(conn, %{"id" => id}) do

    data_directory = Application.get_env(:imagex, :runtime)[:data_directory]
    filepath = Path.join([data_directory, id])
    case File.rm(filepath) do
      :ok ->
        conn
        |> send_resp(204, "")
      {:error, :enoent} ->
        conn
        |> send_resp(404, "")
      {:error, _} ->
        conn
        |> send_resp(400, "")
    end
  end

  defp get_suffix(content_type) do
    case suffix = Enum.at(String.split(content_type, "/"), 1) do
      "jpeg" ->
        "jpg"
      _ ->
        suffix
    end
  end

  defp get_filename(content_type, image_id) do
    "#{image_id}.#{get_suffix(content_type)}"
  end
end
