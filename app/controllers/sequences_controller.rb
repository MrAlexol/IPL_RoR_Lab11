# my class
class SequencesController < ApplicationController
  before_action :set_sequence, only: %i[ show edit update destroy ]
  # Get user input
  def input; end

  # GET /sequences or /sequences.json
  def index
    @sequences = Sequence.all
  end

  # GET /sequences/1 or /sequences/1.json
  def show
  end

  # GET /sequences/new
  def new
    @sequence = Sequence.new
  end

  # GET /sequences/1/edit
  def edit
  end

  # POST /sequences or /sequences.json
  def create
    @sequence = Sequence.new(make_record)

    respond_to do |format|
      if @sequence.save
        format.html { redirect_to @sequence, notice: "Sequence was successfully created." }
        format.json { render :show, status: :created, location: @sequence }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sequences/1 or /sequences/1.json
  def update
    respond_to do |format|
      if @sequence.update(sequence_params)
        format.html { redirect_to @sequence, notice: "Sequence was successfully updated." }
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
      format.html { redirect_to sequences_url, notice: "Sequence was successfully destroyed." }
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

    def make_record
      input = sequence_params[:values].split(' ')
      puts '=------input------='
      puts input

      subs_arr = find_increasing_subs(input).filter { |arr| arr.count > 1 }
      subs = subs_arr.map { |subseq| subseq.join(' ') }
      result = subs_arr.max_by(&:length).join(' ')
      input = input.join(' ')

     # calc_hash = subs.each_with_object({}).with_index { |m, ind| m[1]["s%20i=#{ind}"] = m[0] }
     calc_hash = subs.each_with_object({}).with_index(1) { |m, ind| m[1]["s#{ind}"] = m[0] }
     
      ans_hash = { s: result }
      output_hash = { calc: calc_hash, ans: ans_hash }
      output_xml = output_hash.to_xml.gsub('hash', 'output').gsub(/<s(\d)>/, '<s i="\1">').gsub(/<\/s(\d)>/, '</s>')
      puts output_xml
      puts '=======MYXML========'
      puts output_xml
      
      # Hash.new(calc: )
      # xml_result = ''
      # subs.each_with_object.with_index('') { |el, acc, ind| "" }
    # rescue StandardError => e
    #   @error = case e.class.to_s
    #            when 'ArgumentError' then 'Введены посторонние символы'
    #            when 'NoMethodError' then 'Последовательность не найдена'
    #            else e
    #            end
    # ensure
      puts '=-----result------='
      puts result
      { values: input, output: output_xml }
    end

    def find_increasing_subs(input)
        input.each_with_object([[]]) do |el, acc|
        acc << [] if acc[-1].any? && el <= acc[-1][-1]
        acc[-1] << el
      end
    end
end
