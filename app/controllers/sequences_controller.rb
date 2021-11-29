# frozen_string_literal: true

require 'nokogiri'

# my class
class SequencesController < ApplicationController
  before_action :set_sequence, only: %i[show edit update destroy]
  XSLT_SHOW_TRANSFORM = "#{Rails.root}/public/server_transform.xslt".freeze
  helper_method :make_output
  # GET /sequences or /sequences.json
  def index
    @sequences = Sequence.last(50) # будем выводить лишь последние 50 записей
    respond_to do |format|
      format.html do # Вывод списка записей в формате html
        render 'index'
      end
      format.xml do # Вывод списка записей в едином XML
        p xml_arr = @sequences.inject([]) { |acc, el| acc.append el.output }
        doc_result = Nokogiri::XML('<db></db>')
        xml_arr.each_with_object(doc_result) do |el, acc|
          el = Nokogiri::XML(el).search('output')
          acc.at('db').add_child(el)
        end
        render xml: doc_result
      end
    end
    # @sequences = Sequence.search(params[:values])
  end

  # GET /sequences/1 or /sequences/1.json
  def show
    # В базе данных поле Output хранится в формате XML.
    # Преобразуем его в таблицу для вывода пользователю
    doc = Nokogiri::XML(@sequence.output)
    xslt = Nokogiri::XSLT(File.read(XSLT_SHOW_TRANSFORM))
    @show_result = xslt.transform(doc)
  end

  # GET /sequences/new
  def new
    @sequence = Sequence.new
  end

  # GET /sequences/1/edit
  def edit; end

  # POST /sequences or /sequences.json
  def create
    @sequence = Sequence.new(sequence_params)
    # Рассчитаем поле Output, если пользователь ввел корректную последовательность
    @sequence.output = make_output(sequence_params[:values]) if @sequence.valid?
    # Проверим, есть ли в БД данная последовательность.
    found_id = Sequence.search_id(sequence_params[:values])
    if found_id.nil?
      respond_to do |format|
        if @sequence.save
          format.html { redirect_to @sequence, notice: 'Sequence was successfully created.' }
          format.json { render :show, status: :created, location: @sequence }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @sequence.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to action: 'show', id: found_id
    end
  end

  # PATCH/PUT /sequences/1 or /sequences/1.json
  def update
    respond_to do |format|
      if @sequence.update(sequence_params)
        format.html { redirect_to @sequence, notice: 'Sequence was successfully updated.' }
        format.json { render :show, status: :ok, location: @sequence }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequences/1 or /sequences/1.json
  def destroy
    @sequence.destroy
    respond_to do |format|
      format.html { redirect_to sequences_url, notice: 'Sequence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sequence
    @sequence = Sequence.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sequence_params
    params.require(:sequence).permit(:values)
  end

  def make_output(input)
    input = input.split(' ').map { |el| Integer el }
    return if input.nil? || input.empty?

    subs_arr = find_increasing_subs(input).filter { |arr| arr.count > 1 }
    subs = subs_arr.map { |subseq| subseq.join(' ') }
    result = subs_arr.max_by(&:length)&.join(' ')
    calc_hash = subs.each_with_object({}).with_index(1) { |m, ind| m[1]["s#{ind}"] = m[0] }

    ans_hash = { s: result || 'Не найдено' }
    output_hash = { calc: calc_hash, ans: ans_hash }
    # Сформируем XML для записи в БД
    output_hash.to_xml.gsub('hash', 'output').gsub(/<s(\d)>/, '<s i="\1">').gsub(%r{</s(\d)>}, '</s>')
  end

  def find_increasing_subs(input)
    input.each_with_object([[]]) do |el, acc|
      acc << [] if acc[-1].any? && el <= acc[-1][-1]
      acc[-1] << el
    end
  end
end
